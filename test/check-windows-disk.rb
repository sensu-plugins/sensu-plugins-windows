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

      allow(check)
        .to receive(:`)
        .with('wmic volume where DriveType=3 list brief /format:csv')
        .and_return(mock_wmic)
    end

    def check_mount_point(mnt)
      check.config[:mount_points] = [mnt]
      expect do
        begin
          check.run
        rescue SystemExit # rubocop:disable HandleExceptions
        end
      end
    end

    it 'should match CRITICAL when checking C: drive' do
      check_mount_point('C:\\').to output(/CheckDisk CRITICAL/).to_stdout
    end

    it 'should match OK when checking D: drive' do
      check_mount_point('D:\\').to output(/CheckDisk OK/).to_stdout
    end
  end
end
