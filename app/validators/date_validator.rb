class DateValidator < ActiveModel::EachValidator
  private def validate_each(record, attribute, value)
    if value.blank? || !Date.parse(value.strftime('%Y-%m-%d'))
      record.errors.add(attribute, "正しい形式で日付を入力してください。")
    end
  end
end
