class Recommendify::JaccardProcessor < Recommendify::Processor

  attr_reader :ccmatrix

  def initialize(opts={})
    super(opts)
    @ccmatrix = Recommendify::SparseMatrix.new(
      :redis_prefix => @opts.fetch(:redis_prefix),
      :key => [@opts.fetch(:key), :ccmatrix].join(":")
    )
  end

  def add_set(set_id, item_ids)
    item_ids.each do |item_id|
      item_count_incr(item_id)
    end
    all_pairs(item_ids).map do |pair| 
      i1, i2 = pair.split(":") 
      @ccmatrix.incr(i1, i2)
    end
  end

  def similarity(item1, item2)
    calculate_jaccard_cached(item1, item2)
  end

  def similarities_for(item1)
    (all_items - [item1]).map do |item2|
      [item2, similarity(item1, item2)]
    end
  end

  def all_items
    Recommendify.redis.hkeys(redis_key(:items))
  end

private

  def all_pairs(keys)
    keys.map{ |k1| (keys-[k1]).map{ |k2| [k1,k2].sort.join(":") } }.flatten.uniq
  end

  def item_count_incr(key)
    Recommendify.redis.hincrby(redis_key(:items), key, 1)
  end

  def item_count(key)
    Recommendify.redis.hget(redis_key(:items), key).to_i
  end

  def calculate_jaccard_cached(item1, item2)
    val = @ccmatrix[item1, item2]
    val.to_f / (item_count(item1)+item_count(item2)-val).to_f
  end

  def calculate_jaccard(set1, set2)
    (set1&set2).length.to_f / (set1 + set2).uniq.length.to_f
  end

end