json.array!(@commits) do |commit|
  json.extract! commit, :id, :oid, :image_uid, :branch_id
  json.url commit_url(commit, format: :json)
end
