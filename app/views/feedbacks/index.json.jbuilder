json.array!(@feedbacks) do |feedback|
  json.extract! feedback, :name, :email, :comment
  json.url feedback_url(feedback, format: :json)
end