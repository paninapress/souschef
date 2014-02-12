module MyRecipesHelper
  AWS::S3::Base.establish_connection!(
    :access_key_id     => ENV['access_key_id'],
  :secret_access_key => ENV['secret_access_key'])

  def download_url_for(file)
    @file = 'app/assets/audios/#{@myrecipes.title}.mp3'
    AWS::S3::S3Object.url_for(@file, 'tennis-testing', :authenticated => false)
  end

end
