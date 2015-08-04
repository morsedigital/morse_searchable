require 'spec_helper'


describe Searchable do

  let(:sample) { new_sample }
  let(:some_samples) { [new_sample] }
  let(:no_samples) { [] }
  let(:color) { new_color }
  let(:some_colors) { [new_color] }
  let(:no_colors) { [] }

  let(:fakes_controller){FakesController.new}
  let(:feed_non_specific){
                      {feed: {klass: Sample, non_associated_fields: [:barcode]}, 
                       collection: [
                                     {filterable: ClothingType, fields: [:title, :poop]}, 
                                     {filterable: Color, fields: [:title, :code] }
                                   ]
                      }
                    }
  let(:feed_universe){
                      {feed: {klass: Sample, universe: some_samples, non_associated_fields: [:barcode]}, 
                       collection: [
                                     {filterable: ClothingType, fields: [:title, :poop]}, 
                                     {filterable: Color, fields: [:title, :code] }
                                   ]
                      }
                    }
  let(:feed_vanilla){
                      {feed: {klass: Sample, scope: :all, non_associated_fields: [:barcode]}, 
                       collection: [
                                     {filterable: ClothingType, fields: [:title, :poop]}, 
                                     {filterable: Color, fields: [:title, :code] }
                                   ]
                      }
                    }
  let(:feed_vanilla_with_universe){
                      {feed: {klass: Sample, scope: :all, non_associated_fields: [:barcode]}, 
                       collection: [
                                     {filterable: ClothingType, fields: [:title, :poop]}, 
                                     {filterable: Color, universe:some_colors, fields: [:title, :code] }
                                   ]
                      }
                    }
  let(:feed_vanilla_with_universe_with_field_types){
                    {feed: {klass: Sample, scope: :all, non_associated_fields: [:barcode]}, 
                     collection: [
                                   {filterable: ClothingType, fields: [:title, :poop], input_type: :select}, 
                                   {filterable: Color, universe:some_colors, fields: [:title, :code], input_types: :select }
                                 ]
                    }
                  }




  before do
    fakes_controller.set_meta_filters_here(feed_vanilla)
  end

  describe "apply_scope" do
    it "should apply the scope" do
      expect(Sample).to receive(:all).at_least(:once)
        fakes_controller.send(:apply_scope)
    end
    it "should return an ARR" do

      expect(fakes_controller.send(:apply_scope)).to be_a(Array)
    end
  end

  describe "build_filters" do
    it "does something" do
      fakes_controller.send(:build_filters)
    end
  end

  describe "data_pool" do
    context "where a scope is given" do
      it "should apply the scope" do
        expect(fakes_controller).to receive(:apply_scope).at_least(:once)
        fakes_controller.send(:data_pool)
      end
      it "should return an ARR" do
        expect(fakes_controller.send(:data_pool)).to be_a(Array)
      end
    end

    context "where a universe is given" do
      before do
        fakes_controller.set_meta_filters_here(feed_universe)
      end
      it "should return the universe" do
        expect(fakes_controller.send(:data_pool)).to eq(some_samples) 
      end
    end

    context "where neither scope nor universe is given" do
      before do
        fakes_controller.set_meta_filters_here(feed_non_specific)
      end
      it "should return the universe" do
        expect(fakes_controller.send(:data_pool)).to eq(Sample.all) 
      end
    end
  end

  describe "operable_klass" do
    it "should return the correct klass" do
      expect(fakes_controller.send(:operable_klass)).to eq(Sample)
    end
  end
  
  describe "sanitize_filters" do
    context "where a input type is passed" do
      before do
        fakes_controller.set_meta_filters_here(feed_vanilla_with_universe_with_field_types)
      end
      it "should include the input type in filter hash" do
        expect(fakes_controller.send(:sanitize_filters)[ClothingType]).to include(:input_type => :select)
      end
    end
  end

  describe "sanitized_filters" do
    subject{fakes_controller.send(:sanitized_filters)[ClothingType]}
    it { is_expected.to include(:fields => [:id, :title]) }
    context "removing junk attributes" do 
      subject{fakes_controller.send(:sanitized_filters)[ClothingType][:fields]}
      it { is_expected.to_not include(:poop) }
      describe "it always includes id" do 
        it { is_expected.to include(:id) }
      end
    end
  end

end

