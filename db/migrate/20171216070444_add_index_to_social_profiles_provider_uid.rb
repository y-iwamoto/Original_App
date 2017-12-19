class AddIndexToSocialProfilesProviderUid < ActiveRecord::Migration[5.1]
  def change
    add_index :social_profiles, [:provider, :uid], unique: true
  end
end
