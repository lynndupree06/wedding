class Photo < ActiveRecord::Base
  has_attached_file :avatar,
                    :styles => {
                        :medium => '300x300>',
                        :thumb => '100x100>'
                    },
                    :default_url => '/images/:style/missing.png',
                    :storage => :s3,
                    :bucket => AppConstants.s3_bucket_name,
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials },
                    :url => '/photos/:id/:style/:basename.:extension',
                    :path => 'photos/:id/:style/:basename.:extension'

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def s3_credentials
    {
        :bucket => AppConstants.s3_bucket_name,
        :access_key_id => AppConstants.aws_access_key_id,
        :secret_access_key => AppConstants.aws_secret_access_key
    }
  end
end
