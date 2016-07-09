class InvalidStudentCodeError < NameError
  def initialize(msg="invalid email or password")
    super(msg)
  end
end
