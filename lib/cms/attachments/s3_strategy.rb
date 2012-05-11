module Cms
  module Attachments
    
    # Automatically used to serve files when the following configuration is set:
    #   config.cms.attachments.storage = :s3
    class S3Strategy
      
      # Redirects users to the file on S3.
      def self.send_attachment(attachment, controller)
        controller.redirect_to attachment.url
      end
    end
  end
end
