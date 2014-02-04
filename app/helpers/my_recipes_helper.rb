module MyRecipesHelper
  AWS::S3::Base.establish_connection!(
    :access_key_id     => 'AKIAI6AECUXY23A6B56Q',
  :secret_access_key => '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',)
  def download_url_for(file)
    @file = 'app/assets/audios/recipe_id.mp3'
    AWS::S3::S3Object.url_for(@file, 'tennis-testing', :authenticated => false)
  end
end
