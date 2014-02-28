class S3Bucket

  attr_reader :bucket_name, :region
  
  def initialize(options = {}) 
    defaults = { bucket_name: "",
                 region: "eu-west-1",
                 dry_run: false
    }
    if (options.keys - defaults.keys).empty?
      params = defaults.merge options
      @bucket_name = params[:bucket_name]
      @region = params[:region]
      @dry_run = params[:dry_run]
    else
      raise "#{self.class}: unrecognized parameters #{options.keys - defaults.keys}"
    end
    
    @s3_domain = "amazonaws.com"
    @s3_host_prefix = "s3-website"
  end

  def sync(source,delete_removed=false,dry_run=@dry_run)
    exec "s3cmd sync #{delete_removed ? '--delete-remove' : ''} #{source}/ " +
         s3cmd_string(dry_run)
  end
  
  def ls
    cmd = "s3cmd ls " + s3cmd_string(false)
    exec cmd
  end

  def static_hosting_url
    "http://#{bucket_name}.#{@s3_host_prefix}-#{@region}.#{@s3_domain}"
  end



  private 

  def s3cmd_string(dry_run)
    cmd = "#{dry_run ? '--dry-run'  : ''} " +
          "--bucket-location=#{@region} " +
          "s3://#{@bucket_name}"
  end


  # sh "s3cmd sync " +
  #    source_loc +
  #    #" --dry-run" +
  #    " --bucket-location=" + bucket_loc + 
  #    " s3://" + bucket_name_stage
  
end


if __FILE__ ==$0
  s3b = S3Bucket.new({bucket_name: "soc-sitetest",
                      region: "eu-west-1",
                      :dry_run => true
  })
  #s3b.ls
  #s3b.sync("_site")
  puts s3b.static_hosting_url

end