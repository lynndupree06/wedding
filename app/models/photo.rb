class Photo < ActiveRecord::Base
  has_attached_file :avatar,
                    :styles => {
                        :medium => '300x300>',
                        :thumb => '100x100>'
                    },
                    :default_url => '/images/:style/missing.png',
                    :storage => :s3,
                    :bucket => ENV['S3_BUCKET_NAME'],
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials },
                    :url => '/photos/:id/:style/:basename.:extension',
                    :path => 'photos/:id/:style/:basename.:extension'

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def s3_credentials
    {
        :bucket => ENV['S3_BUCKET_NAME'],
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }
  end
end
