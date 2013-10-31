json.array!(@mailguns) do |mailgun|
  json.extract! mailgun, :sender, :recipient, :subject, :stripped-text
  json.url mailgun_url(mailgun, format: :json)
end