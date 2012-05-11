module Cms
  module S3
    class << self
      attr_accessor :enabled
      attr_accessor :heroku_caching
      attr_accessor :www_domain_prefix
      attr_accessor :options
    end
    # module AttachmentsController
    #       def self.included(controller_class)
    #         controller_class.alias_method_chain :show, :s3
    #       end
    #       
    #       def show_with_s3
    #         @attachment = Cms::Attachment.find(params[:id])
    #         @attachment = @attachment.as_of_version(params[:version]) if params[:version]
    #         if Cms::S3.enabled
    #           #get the file off S3
    #           redirect_to @attachment.url
    #           # if Cms::S3.options[:s3_cname]
    #             # redirect_to("http://#{Cms::S3.options[:s3_cname]}/#{@attachment.file_location}")
    #           # else
    #             # redirect_to("http://#{Cms::S3.options[:bucket]}.s3.amazonaws.com/#{@attachment.file_location}")
    #           # end
    #         else
    #           #Construct a path to where this file would be if it were cached
    #           @file = @attachment.full_file_location
    # 
    #           #Stream the file if it exists
    #           if @path != "/" && File.exists?(@file)
    #             send_file(@file, 
    #             :filename    => @attachment.file_name,
    #             :type        => @attachment.file_type,
    #             :disposition => "inline"
    #             )
    #           end
    #         end
    #       end
    #     end
    module ContentController
      def self.included(controller_class)
        controller_class.alias_method_chain :render_page_with_caching, :s3
        # controller_class.alias_method_chain :try_to_stream_file, :s3
      end
      def render_page_with_caching_with_s3
        render_page
        response.headers['Cache-Control'] = 'public, max-age=300' if Cms::S3.heroku_caching
      end
      
    end
    
    module ApplicationController
      def self.included(controller_class)
        controller_class.alias_method_chain :url_without_cms_domain_prefix, :www
      end
      def url_without_cms_domain_prefix_with_www
        if Cms::S3.www_domain_prefix
          request.url.sub(/#{cms_domain_prefix}\./,'www.')
        else
          request.url.sub(/#{cms_domain_prefix}\./,'')
        end
      end
    end
  end
end


