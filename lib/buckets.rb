class LeoTamer
  configure do
    @@manager ||= LeoFSManager::Client.new(*Config[:managers])
  end

  namespace "/buckets" do
    get "/list.json" do
      buckets = @@manager.s3_get_buckets
      result = buckets.map do |bucket|
        { 
          :name => bucket.name,
          :owner => bucket.owner,
          :created_at => bucket.created_at
        }
      end
      { data: result }.to_json
    end

    post "/add_bucket" do
      bucket_name = params[:bucket]
      access_key = Config[:credential][:access_key_id]
      @@manager.s3_add_bucket(bucket_name, access_key)
      nil
    end
  end
end
