module ApplicationHelper

  AWS::S3::Base.establish_connection!(
    :access_key_id     =>  ENV['access_key_id'],
  :secret_access_key => ENV['access_key_id'])
  def download_url_for(file)
    @file = 'app/assets/audios/recipe_id.mp3'
    AWS::S3::S3Object.url_for(@file, 'tennis-testing', :authenticated => false)
  end
end
