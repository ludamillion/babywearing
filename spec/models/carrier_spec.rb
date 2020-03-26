# frozen_string_literal: true

RSpec.describe Carrier do
  let(:washington) { locations(:washington) }
  let(:lancaster) { locations(:lancaster) }
  let(:category) { categories(:category) }

  describe "associations" do
    it { is_expected.to belong_to(:organization) }
  end

  it 'has a valid fixture' do
    expect(carriers(:carrier)).to be_valid
    expect(carriers(:unavailable)).to be_valid
    expect(carriers(:disabled)).to be_valid
    expect(carriers(:sold)).to be_valid
  end

  it "has a photo attached" do
    carrier = described_class.new
    file = Rails.root.join('public', 'apple-touch-icon.png')
    carrier.photos.attach(io: File.open(file), filename: 'apple-touch-icon.png')
    assert carrier.photos.attached?
  end

  it 'is not valid without an item_id' do
    expect(described_class.new(item_id: nil)).not_to be_valid
  end

  it 'is not valid without a name' do
    expect(described_class.new(name: nil)).not_to be_valid
  end

  it 'is not valid without a manufacturer' do
    expect(described_class.new(manufacturer: nil)).not_to be_valid
  end

  it 'is not valid without an model' do
    expect(described_class.new(model: nil)).not_to be_valid
  end

  it 'is not valid without a color' do
    expect(described_class.new(color: nil)).not_to be_valid
  end

  it 'is not valid without a home_location_id' do
    expect(described_class.new(home_location_id: nil)).not_to be_valid
  end

  it 'is not valid without a current_location_id' do
    expect(described_class.new(current_location_id: nil)).not_to be_valid
  end

  describe '#build_loan' do
    let(:carrier) { described_class.first }

    context "without parameters" do
      subject(:loan) { carrier.build_loan }

      it 'creates a loan with the default due date set' do
        expect(loan.due_date).to eq Date.today + carrier.default_loan_length_days.days
      end
    end
  end

  describe '#display_name' do
    let(:carrier) { carriers(:carrier) }
    let(:manufacturer) { 'manny' }
    let(:model) { 'my model' }

    context 'with no manufacturer or model' do
      it 'returns the empty string' do
        carrier.manufacturer = ''
        carrier.model = ''

        expect(carrier.display_name).to eq('')
      end
    end

    context 'with manufacturer only' do
      it 'contains the manufacturer' do
        carrier.manufacturer = manufacturer
        carrier.model = ''

        expect(carrier.display_name).to eq(manufacturer)
      end
    end

    context 'with model only' do
      it 'contains the model' do
        carrier.manufacturer = ''
        carrier.model = model

        expect(carrier.display_name).to eq(model)
      end
    end

    context 'with both manufacturer and model' do
      it 'contains them both' do
        carrier.manufacturer = manufacturer
        carrier.model = model

        expect(carrier.display_name).to eq("#{manufacturer} #{model}")
      end
    end
  end
end
