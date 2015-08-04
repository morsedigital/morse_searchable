module Searchable

  ACCEPTED_INPUT_TYPES = [:select, :checkbox, :radio]

  extend ActiveSupport::Concern
  #current defects - possibly issue handling non validated association fields
                    #not set up to use has many yet

  DEFAULT_FIELDS = [:id]

  def feed
    respond_to do |format|
      if sanitized_klass
        format.json { render 'api/search/feed', layout: false, locals: { feed: data_pool, fields: attributes } }
      else
        format.json { render :json => {:error => "Check module configuration settings"}, status: 404 }
      end
    end
  end

  def filters
    respond_to do |format|
      if sanitized_filters
        format.json { render 'api/search/filters', layout: false, locals: { filters: build_filters } }
      else
        format.json { render :json => {:error => "Check module configuration settings"}, status: 404 }
      end
    end
  end

  private

  def apply_scope
    operable_klass.send(sanitized_klass[:scope])
  end

  def attributes
    association_fields = {}
    association_fields[:main] = sanitized_klass[:attributes]
    sanitized_filters.each do |obj,attrs|
      association = klass_to_symbol(obj)
      if sanitized_klass[:klass].new.respond_to?(association)
        arr=attrs.select { |atr| atr unless DEFAULT_FIELDS.include?(atr) }
        association_fields[association] = arr if arr.any?
      end
      association_fields
    end
    association_fields
  end

  def build_filters
    filterable_hash = {}
    sanitized_filters.each do |filter, options|
      if filter.select(options[:fields]).any?
        a=klass_to_symbol(filter)
        filterable_hash[a]={}
        filterable_hash[a][:filters_by] = filter.name
        filterable_hash[a][:collection] = filter.where(id: filter.pluck(:id))
        filterable_hash[a][:fields] = options[:fields].map {|f| f if filter.instance_methods.include?(f) }
        filterable_hash[a][:input_type] = options[:input_type]
      end
    end
    filterable_hash
  end

  def data_pool
    return apply_scope if sanitized_klass.key? :scope
    return sanitized_klass[:universe] if sanitized_klass.key? :universe
    operable_klass.send(:all)
  end

  def klass_keys(k)
    k.new.attributes.keys.map { |k| k.to_sym }
  end

  def klass_to_symbol(k)
    k.name.underscore.to_sym
  end

  def operable_klass
    sanitized_klass[:klass]
  end

  def sanitize_klass
    @sanitized_klass = {}
    if @filter_feed[:klass]
      @sanitized_klass[:klass] = @filter_feed[:klass]
      @sanitized_klass[:universe] = @filter_feed[:universe] if @filter_feed.key? :universe
      @sanitized_klass[:attributes] = []
      @filter_feed[:non_associated_fields].collect { |naf| @sanitized_klass[:attributes] << naf if @filter_feed[:klass].new.respond_to?(naf) }
      @sanitized_klass[:scope] = @filter_feed[:scope] if @filter_feed.key?(:scope) and  @filter_feed[:klass].respond_to?(@filter_feed[:scope])
    end
    @sanitized_klass
  end

  def sanitize_filters
    @sanitized_filters = {}
    @filter_collection.each do |filter|
      klass = filter[:filterable]
      attributes = filter[:fields]
      safe_filters = []
      safe_filters.push(*DEFAULT_FIELDS)
      attributes.map { |f| safe_filters << f if klass.new.respond_to?(f) }
      @sanitized_filters[klass] = {}
      @sanitized_filters[klass][:fields] = safe_filters
      # raise ACCEPTED_INPUT_TYPES.inspect
      @sanitized_filters[klass][:input_type] = filter[:input_type] if ACCEPTED_INPUT_TYPES.include?(filter[:input_type])
    end
    @sanitized_filters
  end

  def sanitized_filters
    @sanitized_filters
  end

  def sanitized_klass
    @sanitized_klass
  end

  def set_meta_filters(args={})
    @filter_feed=args[:feed]
    @filter_collection=args[:collection]
    sanitize_klass
    sanitize_filters
  end
end