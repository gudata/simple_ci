# General states for something which could be executed
# currently scripts and builds
module Runnable
  extend ActiveSupport::Concern

  States = {
    pending: 0,
    running: 1,
    success: 2,
    failed: 3,
    unknown: 4,
    canceled: 5,
  }

  included do
    scope :pending, ->() { where(state: States[:pending])}
    scope :running, ->() { where(state: States[:running])}
    scope :success, ->() { where(state: States[:success])}
    scope :failed, ->() { where(state: States[:failed])}
    scope :unknown, ->() { where(state: States[:unknown])}

    state_machine :state, initial: :pending do

      before_transition pending: :running do |runnable|
        runnable.update_attribute(:started_at, Time.now)
      end

      after_transition running: any do |runnable|
        runnable.update_attribute(:finished_at, Time.now)

        time_diff = runnable.finished_at - runnable.started_at
        total_time = Time.at(time_diff.to_i.abs).utc.strftime "%H:%M:%S"
        runnable.update_attribute(:total_time, total_time)
      end

      state :pending, value: States[:pending] do
      end

      state :running, value: States[:running] do
      end

      state :success, value: States[:success] do
      end

      state :failed, value: States[:failed] do
      end

      state :unknown, value: States[:unknown] do
      end

      state :canceled, value: States[:canceled] do
      end

      event :mark_pending do
        transition [:failed, :unknown, :success, :canceled] => :pending
      end

      event :mark_success do
        transition running: :success
      end

      event :mark_running do
        transition pending: :running
      end

      event :mark_unknown do
        transition running: :unknown
      end

      # Forced stop
      event :mark_failed do
        transition running: :failed
      end

      event :cancel do
        transition [:unknown, :pending, :canceled] => :canceled
      end

    end # state machine

  end # included

end