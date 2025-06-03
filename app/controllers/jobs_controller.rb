# app/controllers/jobs_controller.rb
require "active_record"

class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin!, except: [:index, :show]

  def index
    @jobs = Job.all
  end

  def show
    # 26. pass user with accessing property
    user = User.find_by(email: 'rajkumar@gmail.com')
    puts User.where(id: user) // passing user object directly is deprecated
    # puts User.where(id: user.id) // pass with id

    # 27.
    user = User.first
    # Type cast attributes to database values
    email_db_value = user.class.attribute_types["email"].serialize(user.email)
    User.where(email: email_db_value) 

    # 28 no need manulal typecast anymore
    User.where(email: User.type_cast("John"))

    # Automatic typecast supported
    # User.where(email: user.name) 

    # 31 
    User.reorder(nil).first // removes any default ordering that might be present in the model definition or previous query scopes

    # puts 'User.order(:created_at).first'


    # 32 Remove below methods
    env = "development"
    db_name = "primary"

    up_to_date = ActiveRecord::Tasks::DatabaseTasks.schema_up_to_date?(env, db_name)
    puts "Schema up to date? #{up_to_date}"

    # up_to_date = ActiveRecord::Tasks::DatabaseTasks.schema_up_to_date?
    # puts "Schema up to date? #{up_to_date}"

    # Generate database dump filename
    filename = ActiveRecord::Tasks::DatabaseTasks.dump_filename("development")
    puts "Dump Filename: #{filename}"

    # Get the path to the schema file
    schema_path = ActiveRecord::Tasks::DatabaseTasks.schema_file("development")
    puts "Schema File: #{schema_path}"

    # Get the database specification for the environment
    db_spec = ActiveRecord::Tasks::DatabaseTasks.spec("development")
    puts "Database Spec: #{db_spec.inspect}"

    # Retrieve the current database configuration
    current_config = ActiveRecord::Tasks::DatabaseTasks.current_config
    puts "Current Database Config: #{current_config.inspect}"

    # 33 Removed below methods and no replacements
    ActiveRecord::Tasks::DatabaseTasks.dump_filename = "db/custom_schema.rb"
    ActiveRecord::Tasks::DatabaseTasks.schema_file = "db/schema.rb"
    ActiveRecord::Tasks::DatabaseTasks.spec = Rails.application.config.database_configuration

    # 34 Removed below behaviours
    max_in_length = ActiveRecord::Base.connection.in_clause_length
    puts "Max allowed IN clause length: #{max_in_length}"

    max_length = ActiveRecord::Base.connection.allowed_index_name_length
    puts "Max allowed index name length: #{max_length}"

    # 35 Removed Below Behaviours

# Fetch spec name from database configurations
config = ActiveRecord::Base.configurations.configs_for(env: "development", spec_name: "primary")
puts "Database Spec Name: #{config.spec_name}"

# Get the current connection config
connection_config = ActiveRecord::Base.connection_config
puts "Current Connection Config: #{connection_config.inspect}"

# Convert attribute into Arel representation (useful for dynamic queries)
email_attr = User.arel_attribute(:email)
puts "Arel Attribute for Email: #{email_attr.to_sql}"

# Retrieve the default database config hash
default_db_config = ActiveRecord::Base.configurations.default_hash
puts "Default Database Config Hash: #{default_db_config.inspect}"

# Convert all configurations into a hash representation
all_db_configs = ActiveRecord::Base.configurations.to_h
puts "All Database Configurations: #{all_db_configs.inspect}"

# 36 Remove deprecated ActiveRecord::Result#map! and ActiveRecord::Result#collect!.

result = User.where(name: 'Alice')
result.map! { |user| user.name }  # Mutates the result directly

result.collect! { |user| user.name }  # mutating collect

# result = User.where(name: 'Alice')
# result.map { |user| user.name }  # Safe non-mutating version

# result.collect { |user| user.name }  # Non-mutating collect


# 37 Removed below methods
# Disconnect from the database
ActiveRecord::Base.remove_connection

# Disconnect from the database using connection pool
# ActiveRecord::Base.connection_pool.disconnect!


# 38 schema_file_type is deprecated

if Tasks::DatabaseTasks.schema_file_type == :ruby
  rake db:schema:load
else
  rake db:structure:load
end

# if Rails.configuration.active_record.schema_format == :ruby
#   rake db:schema:load
# else
#   rake db:structure:load
# end

# 39 Remove deprecated enumeration of ActiveModel::Errors instances as a Hash.
errors.each { |key, messages| puts "#{key}: #{messages}" }

# errors.each { |error| puts "#{error.attribute}: #{error.message}" }

# 40 Remove deprecated ActiveModel::Errors#to_h.
errors.to_h

# errors.to_hash # Explicit method in Rails 7.0

# 41 Remove deprecated ActiveModel::Errors#slice!.
errors.slice!(:name, :email)

# filtered_errors = errors.select { |error| [:name, :email].include?(error.attribute) }

# 42 and 43 ActiveModel::Errors#values & ActiveModel::Errors#keys are removed
errors.values
errors.keys

# errors.map(&:message)  # To get error values
# errors.map(&:attribute) # To get error keys

# 44 ActiveModel::Errors#to_xml removed
errors.to_xml

# errors.to_json # Use JSON instead of XML

# 45, 46, 47 Removed Deprecated support for modifying errors.messages and no alternative
errors.messages.concat
errors.messages.clear
errors.messages.delete

# 48 Removed using []= in ActiveModel::Errors#messages
errors.messages[:attribute] = ["error"]

# 49 . Removed below deprecates
json_data = Marshal.dump(model.attribute_set)
restored_data = JSON.parse(json_data)


    # 53 default_normalization_form removed
    puts ActiveSupport::Multibyte::Unicode.default_normalization_form
    # Possible output: :nfc (default for many Rails apps)

    #Remove the configuration line entirely and handle normalization as needed:
    # string = "some string".mb_chars.normalize(:nfc);

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
    redirect_to jobs_url, notice: 'Job was successfully destroyed.'
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
