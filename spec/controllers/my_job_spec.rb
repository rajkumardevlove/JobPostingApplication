require 'rails_helper'

RSpec.describe MyJob, type: :job do
  include ActiveJob::TestHelper

  before do
    # Use the test adapter so we can inspect the queue
    ActiveJob::Base.queue_adapter = :test
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe 'callbacks' do
    it 'does not enqueue the job because before_enqueue throws :abort' do
      expect {
        MyJob.perform_later('foo', 42)
      }.not_to have_enqueued_job(MyJob)
    end

    it 'does not run after_enqueue when enqueueing is aborted' do
      # Spy on STDOUT to ensure after_enqueue callback never fires
      expect($stdout).not_to receive(:puts).with(/This will NOT run/)
      MyJob.perform_later('foo')
    end

    context 'when before_enqueue is removed' do
      before do
        # Remove only the before_enqueue callbacks to allow enqueueing
        MyJob._enqueue_callbacks.reject! { |cb| cb.kind.equal?(:before) }
      end

      it 'runs after_enqueue callback on perform_later' do
        expect {
          MyJob.perform_later('bar')
        }.to output(/This will NOT run if enqueueing was aborted/).to_stdout
        # And the job should be enqueued
        expect(enqueued_jobs.size).to eq(1)
      end
    end
  end

  describe '#perform' do
    it 'executes perform when run manually' do
      expect {
        MyJob.new.perform('hello', 'world')
      }.to output(/Performing job with args: \["hello", "world"\]/).to_stdout
    end
  end
end
