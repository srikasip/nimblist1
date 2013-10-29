json.array!(@tasks) do |task|
  json.extract! task, :user_id, :item, :is_complete, :deadline, :location
  json.url task_url(task, format: :json)
end