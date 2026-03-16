class AddFailedAttemptsToVerificationCodes < ActiveRecord::Migration[7.2]
  def change
    add_column :verification_codes, :failed_attempts, :integer, default: 0, null: false

  end
end
