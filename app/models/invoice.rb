class Invoice < ActiveRecord::Base
  unloadable

  include ActionView::Helpers::NumberHelper

  belongs_to :invoice_template
  has_one :contractor, :through => :contractor_id
  has_one :recipient, :through => :recipient_id

  has_many :invoice_rows, dependent: :destroy
  accepts_nested_attributes_for :invoice_rows, allow_destroy: true, reject_if: :all_blank

  def set_contractor(company)
    if company
      self.contractor_id = company.id
      self.contractor_name = company.name
      self.contractor_address = company.address
      self.contractor_director_name = company.director_name
      self.contractor_identifier = company.identifier
      self.contractor_vat_number = company.vat_number
      self.contractor_bank_name = company.bank_name
      self.contractor_bank_bic = company.bank_bic
      self.contractor_bank_iban = company.bank_iban
    end
  end

  def set_recipient(company)
    if company
      self.recipient_id = company.id
      self.recipient_name = company.name
      self.recipient_address = company.address
      self.recipient_director_name = company.director_name
      self.recipient_identifier = company.identifier
      self.recipient_vat_number = company.vat_number
      self.recipient_bank_name = company.bank_name
      self.recipient_bank_bic = company.bank_bic
      self.recipient_bank_iban = company.bank_iban
    end
  end

  TEMPLATE_VARS = {
    '[number]': :number,
    '[issue_date]': :issue_date,
    '[total_amount]': :total_amount,
    '[total_amount_words]': :total_amount_words,
    '[total_net_amount]': :total_net_amount,
    '[total_net_amount_words]': :total_net_amount_words,
    '[total_vat_amount]': :total_vat_amount,
    '[total_vat_amount_words]': :total_vat_amount_words,
    '[currency]': :currency,
    '[additional_currency]': :currency,
    '[contractor_name]': :contractor_name,
    '[contractor_address]': :contractor_address,
    '[contractor_director_name]': :contractor_director_name,
    '[contractor_identifier]': :contractor_identifier,
    '[contractor_vat_number]': :contractor_vat_number,
    '[contractor_bank_name]': :contractor_bank_name,
    '[contractor_bank_bic]': :contractor_bank_bic,
    '[contractor_bank_iban]': :contractor_bank_iban,
    '[recipient_name]': :recipient_name,
    '[recipient_address]': :recipient_address,
    '[recipient_director_name]': :recipient_director_name,
    '[recipient_identifier]': :recipient_identifier,
    '[recipient_vat_number]': :recipient_vat_number,
    '[recipient_bank_name]': :recipient_bank_name,
    '[recipient_bank_bic]': :recipient_bank_bic,
    '[recipient_bank_iban]': :recipient_bank_iban,
  }

  INVOICE_ROW_VARS = {
    '[invoice_row_1_title]': {index: 0, field_name: :title},
    '[invoice_row_1_amount]': {index: 0, field_name: :amount},
    '[invoice_row_1_amount_in_currency]': {index: 0, field_name: :amount_in_currency},
    '[invoice_row_1_quantity]': {index: 0, field_name: :quantity},
    '[invoice_row_1_amount_per_hour]': {index: 0, field_name: :amount_per_hour},

    '[invoice_row_2_title]': {index: 1, field_name: :title},
    '[invoice_row_2_amount]': {index: 1, field_name: :amount},
    '[invoice_row_2_amount_in_currency]': {index: 1, field_name: :amount_in_currency},
    '[invoice_row_2_quantity]': {index: 1, field_name: :quantity},
    '[invoice_row_2_amount_per_hour]': {index: 1, field_name: :amount_per_hour},

    '[invoice_row_3_title]': {index: 2, field_name: :title},
    '[invoice_row_3_amount]': {index: 2, field_name: :amount},
    '[invoice_row_3_amount_in_currency]': {index: 2, field_name: :amount_in_currency},
    '[invoice_row_3_quantity]': {index: 2, field_name: :quantity},
    '[invoice_row_3_amount_per_hour]': {index: 2, field_name: :amount_per_hour},

    '[invoice_row_4_title]': {index: 3, field_name: :title},
    '[invoice_row_4_amount]': {index: 3, field_name: :amount},
    '[invoice_row_4_amount_in_currency]': {index: 3, field_name: :amount_in_currency},
    '[invoice_row_4_quantity]': {index: 3, field_name: :quantity},
    '[invoice_row_4_amount_per_hour]': {index: 3, field_name: :amount_per_hour},
  }

  def render_template
    template = ''

    if self.invoice_template
      template = self.invoice_template.template

      TEMPLATE_VARS.each do |variable, field_name|
        template.gsub!(variable.to_s, format_field(self, field_name))
      end

      INVOICE_ROW_VARS.each do |variable, row_config|
        invoice_row = invoice_rows[row_config[:index]]
        if invoice_row
          template.gsub!(variable.to_s, format_field(invoice_row, row_config[:field_name]))
        end
      end
    end

    template
  end

  private

  def format_field(obj, field_name)
    field_type = obj.column_for_attribute(field_name.to_s).type

    if field_type == :date
      obj.send(field_name).strftime('%d.%m.%Y')
    elsif field_type == :decimal
      number_with_precision(obj.send(field_name), precision: 2).to_s
    else
      obj.send(field_name).to_s
    end
  end
end
