module ApplicationHelper

  AWS::S3::Base.establish_connection!(
    :access_key_id     =>  ENV['S3_KEY'],
  :secret_access_key => ENV['S3_SECRET'])
  def download_url_for(file)
    @file = 'app/assets/audios/recipe_id.mp3'
    AWS::S3::S3Object.url_for(@file, 'tennis-testing', :authenticated => false)
  end
end
