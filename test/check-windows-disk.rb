require_relative '../bin/check-windows-disk.rb'

describe CheckDisk do
  before(:all) do
    CheckDisk.class_variable_set(:@@autorun, nil)
  end

  describe '--mount_points flag' do
    let(:check) do
      CheckDisk.new
    end

    before(:each) do
      # Stub the ` method
      mock_wmic = '
Node,Capacity,DriveType,FileSystem,FreeSpace,Label,Name
Localhost,249532772352,3,NTFS,6416957440,CRITICALDrive,C:\\
Localhost,1152921504606846976,3,FAT32,1152921504574169088,OKDrive,D:\\'

      allow(described_class)
        .to receive(:`)
        .with('wmic volume where DriveType=3 list brief /format:csv')
        .and_return(mock_wmic)
    end

    def check_mount_point(check)
      expect do
        begin
          check.run
        rescue SystemExit # rubocop:disable HandleExceptions
        end
      end
    end

    it 'should match CRITICAL when checking C: drive with long flags' do
      check.parse_options ['--mount_points', 'C:\\']
      check_mount_point(check).to output(/CheckDisk CRITICAL/).to_stdout
    end
    
    it 'should match CRITICAL when checking C: drive with short flags' do
      check.parse_options ['--m', 'C:\\']
      check_mount_point(check).to output(/CheckDisk CRITICAL/).to_stdout
    end

    it 'should match OK when checking D: drive with long flags' do
      check.parse_options ['--mount_points', 'D:\\']
      check_mount_point(check).to output(/CheckDisk OK/).to_stdout
    end

    it 'should match OK when checking D: drive with short flags' do
      check.parse_options ['--mount_points', 'D:\\']
      check_mount_point(check).to output(/CheckDisk OK/).to_stdout
    end
  end
end
