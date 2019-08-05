require 'rails_helper'

RSpec.describe ScheduleWindow, type: :model do
   
    describe "Validations" do
      it "should validate start date cannot be later than end date" do
        window =  build(:schedule_window, is_recurring: true, start_date: '2019-10-01', end_date: '2019-09-01')
        expect(window.valid?).to be_falsey
      end

       it "should validate start time cannot be later than end time" do
        window =  build(:schedule_window, is_recurring: true, start_time: '2019-09-02 1600', end_time: '2019-09-02 1300') 
        expect(window.valid?).to be_falsey
      end

      it "should validate start date cannot be later than start time" do
        window = build(:schedule_window, is_recurring: true, start_date: '2019-09-01', start_time: '2019-08-01 12:00') 
        expect(window.valid?).to be_falsey
      end

      it "should validate end date cannot be before end time" do
        window =   build(:schedule_window, is_recurring: true, end_date: '2019-10-02 1600', end_time: '2019-10-12 1400') 
        expect(window.valid?).to be_falsey
      end
    end

    describe "Associations" do
      it { should belong_to(:driver) }
      it { should have_one(:recurring_pattern) }
      it { should belong_to(:location) }
    end

    describe 'Cannot be in the past' do
      it "should validate that start time cannot be in the past" do
        subject.start_time = "2019-07-01"
        subject.valid?  # run validations
        expect(subject.errors[:start_time]).to include('cannot be in the past')
      end

      it "should validate that end time cannot be in the past" do
        subject.end_time = "2019-07-01"
        subject.valid?
        expect(subject.errors[:end_time]).to include('cannot be in the past')
      end

      it "should validate that start date cannot be in the past" do
        subject.start_date = "2019-07-01"
        subject.valid?  # run validations
        expect(subject.errors[:start_date]).to include('cannot be in the past')
      end

      it "should validate that end date cannot be in the past" do
        subject.end_date = "2019-07-01"
        subject.valid?
        expect(subject.errors[:end_date]).to include('cannot be in the past')
      end
    end

    describe 'Cannot be overlapped' do
      it "should validate that end time cannot be before start time" do
        subject.start_time = "2019-07-01 9:00am"
        subject.end_time = "2019-07-01 9:00am"
        subject.valid?  # run validations
        expect(subject.valid?).to be_falsey
      end

      it "should validate that end date cannot be before start date" do
        subject.start_time = "2019-07-01"
        subject.end_time = "2019-07-01"
        subject.valid?  # run validations
        expect(subject.valid?).to be_falsey
      end
      
      describe 'recurring weekly' do
        let(:recurring_pattern) { create(:recurring_weekly_pattern) }
        
        it "should have a weekly recurring_pattern" do
          start_date = Date.parse('2019-09-13')
          end_date = Date.parse('2019-09-27')
          
          events = recurring_pattern.schedule_window.recurring_weekly(start_date, end_date)
          
          # check correct number of events
          expect(events.length).to eq(2)
          
          # check that start times are correct
          start_times = events.map{|k| k[:startTime] }
          expect(start_times).to eq(['2019-09-21 14:00', '2019-09-14 14:00'])
          
          # check that end times are correct
          end_times = events.map{|k| k[:endTime] }
          expect(end_times).to eq(['2019-09-21 16:00', '2019-09-14 16:00'])
        end
        it "query_start_date and query_end_date can not be after start_date" do
          query_start_date = Date.parse('2019-10-27')
          query_end_date = Date.parse('2019-11-27')
           
          events = recurring_pattern.schedule_window.recurring_weekly(query_start_date, query_end_date)
          
          #check that start_time can not be after start_date
          expect(events).to eq([])
      end
       it "query_start_date and query_end_date can not be before start_date" do
          query_start_date = Date.parse('2019-08-01')
          query_end_date = Date.parse('2019-08-31')
           
          events = recurring_pattern.schedule_window.recurring_weekly(query_start_date, query_end_date)
          
          #check that start_time can not be before start_date
          expect(events).to eq([])
        end
        it "query_start_date is before start_date and query_end_date is before the end_date" do
          query_start_date = Date.parse("2019-08-01")
          query_end_date = Date.parse("2019-09-21")
          
          events = recurring_pattern.schedule_window.recurring_weekly(query_start_date, query_end_date)
          
          #testing correct number of events
          expect(events.length).to eq(3)
        
          # check that start times are correct
          start_times = events.map{|k| k[:startTime] }
          expect(start_times).to eq(["2019-09-21 14:00","2019-09-14 14:00","2019-09-07 14:00"])
          
          # check that end times are correct
          end_dates = events.map{|k| k[:endTime] }
          expect(end_dates).to eq(["2019-09-21 16:00", "2019-09-14 16:00", "2019-09-07 16:00"])
        end
        it "query_start_date is after start_date and query_end_date is after the end_date" do
          query_start_date = Date.parse("2019-10-01")
          query_end_date = Date.parse("2019-11-21")
          
          events = recurring_pattern.schedule_window.recurring_weekly(query_start_date, query_end_date)
          
          #testing correct number of events
          expect(events.length).to eq(3)
          puts events
          # # check that start times are correct
          # start_times = events.map{|k| k[:startTime] }
          # expect(start_times).to eq(["2019-09-21 14:00","2019-09-14 14:00","2019-09-07 14:00"])
          
          # # check that end times are correct
          # end_dates = events.map{|k| k[:endTime] }
          # expect(end_dates).to eq(["2019-09-21 16:00", "2019-09-14 16:00", "2019-09-07 16:00"])
        end
      end
    end
end
