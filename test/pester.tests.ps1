describe 'check-windows-cpu-load' {
  it 'should run successfully' {
    .\bin\check-windows-cpu-load.ps1 90 95
  }
}

describe 'check-windows-directory' {
  it 'should run successfully' {
    .\bin\check-windows-directory.ps1 -Dir C:\Users
  }
}

describe 'check-windows-disk-writeable' {
  it 'should run successfully' {
    .\bin\check-windows-disk-writeable.ps1
  }
}

describe 'check-windows-disk' {
  it 'should run successfully' {
    .\bin\check-windows-disk.ps1 90 95 ab
  }
}

describe 'check-windows-event-log' {
  it 'should run successfully' {
    .\bin\check-windows-event-log.ps1 -LogName System -Pattern error
  }
}

describe 'check-windows-http' {
  it 'should run successfully' {
    .\bin\check-windows-http.ps1 https://google.com
  }
}

describe 'check-windows-log' {
  it 'should run successfully' {
    .\bin\check-windows-log.ps1 -LogPath c:\Windows\system.ini -Pattern error
  }
}

describe 'check-windows-pagefile' {
  it 'should run successfully' {
    .\bin\check-windows-pagefile.ps1 75 85
  }
}

describe 'check-windows-process' {
  it 'should run successfully' {
    .\bin\check-windows-process.ps1 WindowsEvent
  }
}

describe 'check-windows-processor-queue-length' {
  it 'should run successfully' {
    .\bin\check-windows-processor-queue-length.ps1 5 10
  }
}

describe 'check-windows-ram' {
  it 'should run successfully' {
      .\bin\check-windows-ram.ps1 90 95
  }
}

describe 'check-windows-service' {
  it 'should run successfully' {
    .\bin\check-windows-service.ps1 System
  }
}

describe 'metric-windows-cpu-load' {
  it 'should run successfully' {
    .\bin\metric-windows-cpu-load.ps1
  }
}

describe 'metric-windows-disk-usage' {
  it 'should run successfully' {
    .\bin\metric-windows-disk-usage.ps1
  }
}

describe 'metric-windows-disk' {
  it 'should run successfully' {
    .\bin\metric-windows-disk.ps1
  }
}
        
describe 'metric-windows-network' {
  it 'should run successfully' {
    .\bin\metric-windows-network.ps1 -Interfaces "ethernet"
  }
}

describe 'metric-windows-processor-queue-length' {
  it 'should run successfully' {
    .\bin\metric-windows-processor-queue-length.ps1
  }
}
    
describe 'metric-windows-ram-usage' {
  it 'should run successfully' {
    .\bin\metric-windows-ram-usage.ps1
  }
}

describe 'metric-windows-system.' {
  it 'should run successfully' {
    .\bin\metric-windows-system.ps1
  }
}

describe 'metric-windows-uptime' {
  it 'should run successfully' {
    .\bin\metric-windows-uptime.ps1
  }
}
