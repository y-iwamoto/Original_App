i = 1
json.array! @schedule_each_date.each do |schedule_each_date|
  json.id schedule_each_date.id
  json.start schedule_each_date.sche_date
  json.title '第'+ i.to_s + '目'
  json.allDay true 
  i = i + 1
end
