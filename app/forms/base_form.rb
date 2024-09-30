class BaseForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Conversion

  def save
    raise NotImplementedError, "You must implement the #{__method__} method"
  end

  def attributes
    super.symbolize_keys
  end

  def new_record?
    raise NotImplementedError, "You must implement the #{__method__} method"
  end

  def persisted?
    !new_record?
  end
end
