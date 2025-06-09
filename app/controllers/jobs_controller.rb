# app/controllers/jobs_controller.rb
require "active_record"
# 4 (rails 7.0) cannot manually require files from these paths
# require "my_custom_service"  # works, due to $LOAD_PATH

class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin!, except: [:index, :show]

  def index
    # @current_time = Time.current.to_s(:db) # 4 => 6.1
    @current_time = Time.current.to_fs(:db) # 4 => 7.0
    @jobs = Job.all
  end

  def show
    # 4 (rails 7.1) Zeitwerk autoloads it
    service = MyCustomService.new
    puts service.call
    # 26. pass user with accessing property
    user = Job.find_by(title: 'Java')
    # puts Job.where(id: user) # passing user object directly is deprecated in 6.1
    Job.where(title: user.title).to_a  # pass with title in 7.0

    # 27. Deprecated below code
    user = Job.first
    # Type cast attributes to database values
    email_db_value = user.class.attribute_types["title"].serialize(user.title)
    Job.where(title: email_db_value) 

    # 28 no need manulal typecast anymore
    #  Job.where(title: Job.type_cast("Java"))

    # Automatic typecast supported
    Job.where(title: user.title) 

    # 31 Deprecated Below Code
    # Job.reorder(nil).first # removes any default ordering that might be present in the model definition or previous query scopes

    # puts 'User.order(:created_at).first'

    # 32 Remove below methods in 6.1
    # env = "development"
    # db_name = "primary"

    # up_to_date = ActiveRecord::Tasks::DatabaseTasks.schema_up_to_date?(env, db_name)
    # puts "Schema up to date? #{up_to_date}"

    # up_to_date = ActiveRecord::Tasks::DatabaseTasks.schema_up_to_date?
    # puts "Schema up to date? #{up_to_date}"

    # 33 Removed below methods and no replacements in 6.1
    # Generate database dump filename
    # filename = ActiveRecord::Tasks::DatabaseTasks.dump_filename("development")
    # puts "Dump Filename: #{filename}"

    # Get the path to the schema file
    # schema_path = ActiveRecord::Tasks::DatabaseTasks.schema_file("development")
    # puts "Schema File: #{schema_path}"

    # Get the database specification for the environment
    # db_spec = ActiveRecord::Tasks::DatabaseTasks.spec("development")
    # puts "Database Spec: #{db_spec.inspect}"

    # Retrieve the current database configuration
    # current_config = ActiveRecord::Tasks::DatabaseTasks.current_config
    # puts "Current Database Config: #{current_config.inspect}"

    # ActiveRecord::Tasks::DatabaseTasks.dump_filename = "db/custom_schema.rb"
    # ActiveRecord::Tasks::DatabaseTasks.schema_file = "db/schema.rb"
    # ActiveRecord::Tasks::DatabaseTasks.spec = Rails.application.config.database_configuration

    # 34 Removed below behaviours in 6.1
    # max_in_length = ActiveRecord::Base.connection.in_clause_length
    # puts "Max allowed IN clause length: #{max_in_length}"

    # max_length = ActiveRecord::Base.connection.allowed_index_name_length
    # puts "Max allowed index name length: #{max_length}"

    # 35 Removed Below Behaviours in 6.1
    # Fetch spec name from database configurations
    # config = ActiveRecord::Base.configurations.configs_for(env: "development", spec_name: "primary")
    # puts "Database Spec Name: #{config.spec_name}"

    # Get the current connection config
    # connection_config = ActiveRecord::Base.connection_config
    # puts "Current Connection Config: #{connection_config.inspect}"

    # Convert attribute into Arel representation (useful for dynamic queries)
    # email_attr = User.arel_attribute(:email)
    # puts "Arel Attribute for Email: #{email_attr.to_sql}"

    # Retrieve the default database config hash
    # default_db_config = ActiveRecord::Base.configurations.default_hash
    # puts "Default Database Config Hash: #{default_db_config.inspect}"

    # Convert all configurations into a hash representation
    # all_db_configs = ActiveRecord::Base.configurations.to_h
    # puts "All Database Configurations: #{all_db_configs.inspect}"

    # 36 Remove deprecated ActiveRecord::Result#map! and ActiveRecord::Result#collect!. in 6.1
    # result = Job.where(title: 'C#').to_a
    # result.map! { |user| user.title }  # Mutates the result directly

    # result.collect! { |user| user.title }  # mutating collect

    # result = Job.where(title: 'Alice').to_a
    # result.map { |user| user.title }  # Safe non-mutating version

    # result.collect { |user| user.title }  # Non-mutating collect


    # 37 Removed below methods
    # Disconnect from the database
    # ActiveRecord::Base.remove_connection

    # Disconnect from the database using connection pool in 7.0
    # ActiveRecord::Base.connection_pool.disconnect!


    # 38 schema_file_type is deprecated
    # if Tasks::DatabaseTasks.schema_file_type == :ruby
    #   rake db:schema:load
    # else
    #   rake db:structure:load
    # end

    # if Rails.configuration.active_record.schema_format == :ruby
    #   rake db:schema:load
    # else
    #   rake db:structure:load
    # end

# 39 Remove deprecated enumeration of ActiveModel::Errors instances as a Hash.
# errors.each { |key, messages| puts "#{key}: #{messages}" }

# errors.each { |error| puts "#{error.attribute}: #{error.message}" }

# 40 Remove deprecated ActiveModel::Errors#to_h.
# errors.to_h

# errors.to_hash # Explicit method in Rails 7.0

# 41 Remove deprecated ActiveModel::Errors#slice!.
# errors.slice!(:name, :email)

# filtered_errors = errors.select { |error| [:name, :email].include?(error.attribute) }

# 42 and 43 ActiveModel::Errors#values & ActiveModel::Errors#keys are removed
# errors.values
# errors.keys

# errors.map(&:message)  # To get error values
# errors.map(&:attribute) # To get error keys

# 44 ActiveModel::Errors#to_xml removed
# errors.to_xml

# errors.to_json # Use JSON instead of XML

# 45, 46, 47 Removed Deprecated support for modifying errors.messages and no alternative
# errors.messages.concat
# errors.messages.clear
# errors.messages.delete

# 48 Removed using []= in ActiveModel::Errors#messages
# errors.messages[:attribute] = ["error"]

# 49 . Removed below deprecates
# json_data = Marshal.dump(model.attribute_set)
# restored_data = JSON.parse(json_data)

    # 52 => 6.1 - 7.0
    # deprecated in Rails 6.1.7+
    # date_range = DateTime.now..(DateTime.now + 1.day)
    # if date_range.cover?(DateTime.now)
    #   puts "Date is within the range"
    # end


    # 53 default_normalization_form removed
    # puts ActiveSupport::Multibyte::Unicode.default_normalization_form
    # Possible output: :nfc (default for many Rails apps)

    #Remove the configuration line entirely and handle normalization as needed:
    # string = "some string".mb_chars.normalize(:nfc);

    # 54 => 6.1 - 7.0
    MyJob.perform_later('hello')
    # => The job will NOT be enqueued because before_enqueue throws :abort
    # => The after_enqueue callback will NOT run due to skip_after_callbacks_if_terminated = true

    # 3. (rails 7.0) 
    # job = Job.find(1)
    # result = job.update_attribute(:title, "Alice")
    # puts "Update result: #{result}"

    # (rails 7.1)
    job = Job.find(1)
    begin
    # This also skips validations...
    # BUT raises an exception if save fails
    job.update_attribute!(:title, "Alice")
    puts "Name updated successfully!"
    rescue ActiveRecord::RecordNotSaved => e
    puts "Failed to save: #{e.message}"
    end

    # 12 (rails 7.0) no longer available in 7.1
    # Set globally in a background job
    # ActiveStorage::Current.host = "http://localhost:3000"

    # Later used by service_url helpers
    # url = user.avatar.service_url

    # rails 7.1
    user.avatar.url # host is derived from `request.base_url`

    # 13 Result: BOTH files are attached in rails 7.0
    # @user.files.attach(io: ..., filename: "file1.pdf")
    # @user.files.attach(io: ..., filename: "file2.pdf")

    # rails 7.1
    user.files = [
    { io: File.open("new.pdf"), filename: "new.pdf" }
    ]

    # 14 (rails 7.0) purge and purge_later
    # user.files.first.purge       # Worked
    # user.files.first.purge_later # Worked

    # Rails 7.1
    user.documents.each(&:purge_later)  


  end

  def new
    @job = current_user.jobs.build
  end

  def create
    @job = current_user.jobs.build(job_params)
    if @job.save
      redirect_to @job, notice: 'Job was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @job.update(job_params)
      redirect_to @job, notice: 'Job was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
   @job.destroy

    respond_to do |format|
      format.turbo_stream   # => renders destroy.turbo_stream.erb
      format.html { redirect_to jobs_path, notice: "Job deleted." }
    end
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:title, :description, :company_name, :location)
  end

  def authorize_admin!
    unless current_user&.admin?
      redirect_to jobs_path, alert: "You are not authorized to perform this action."
    end
  end
end
