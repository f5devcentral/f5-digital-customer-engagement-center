terraform {
  required_version = ">= 0.13.0"
}

locals {
  # Note: these values are either the location of a known Azure data center
  # (as published at https://azure.microsoft.com/en-us/global-infrastructure/data-residency) or
  # the lat/long returned by Google Maps when looking up the city associated
  # with the region.
  lookup = {
    # Canberra
    australiacentral = {
      latitude  = -35.308856
      longitude = 149.115355
    }
    # Canberra
    australiacentral2 = {
      latitude  = -35.308856
      longitude = 149.115355
    }
    # New South Wales
    australiaeast = {
      latitude  = -32.787880
      longitude = 146.023056
    }
    # Victoria
    australiasoutheast = {
      latitude  = -36.997711
      longitude = 143.929297
    }
    # São Paulo State
    brazilsouth = {
      latitude  = -23.553817
      longitude = -46.666744
    }
    # Rio de Janeiro
    brazilsoutheast = {
      latitude  = -22.907112
      longitude = -43.194678
    }
    # Toronto
    canadacentral = {
      latitude  = 43.651618
      longitude = -79.393171
    }
    # Quebec City
    canadaeast = {
      latitude  = 46.813067
      longitude = -71.223596
    }
    # Pune
    centralindia = {
      latitude  = 18.523301
      longitude = 73.854038
    }
    # Iowa
    centralus = {
      latitude  = 41.994622
      longitude = -93.522196
    }
    # Hong Kong
    eastasia = {
      latitude  = 22.325353
      longitude = 114.156529
    }
    # Virginia
    eastus = {
      latitude  = 37.340781
      longitude = -78.964019
    }
    # Virginia
    eastus2 = {
      latitude  = 37.340781
      longitude = -78.964019
    }
    # Paris
    francecentral = {
      latitude  = 48.856578
      longitude = 2.347401
    }
    # Marseille
    francesouth = {
      latitude  = 43.297798
      longitude = 5.373622
    }
    # Berlin
    germanynorth = {
      latitude  = 52.520133
      longitude = 13.398632
    }
    # Frankfurt
    germanywestcentral = {
      latitude  = 50.111881
      longitude = 8.681189
    }
    # Tokyo, Saitama
    japaneast = {
      latitude  = 35.856619
      longitude = 139.629435
    }
    # Osaka
    japanwest = {
      latitude  = 34.675036
      longitude = 135.497021
    }
    # Jio India Central
    jioindiacentral = {
      latitude  = 36.0546162
      longitude = -115.0072807
    }
    # Jio India West
    jioindiawest = {
      latitude  = 36.0546162
      longitude = -115.0072807
    }
    # Seoul
    koreacentral = {
      latitude  = 37.557396
      longitude = 126.991601
    }
    # Busan
    koreasouth = {
      latitude  = 35.167025
      longitude = 129.046980
    }
    # Illinois
    northcentralus = {
      latitude  = 40.266117
      longitude = -89.692218
    }
    # Ireland
    northeurope = {
      latitude  = 53.158664
      longitude = -8.163912
    }
    # Oslo
    norwayeast = {
      latitude  = 59.914439
      longitude = 10.745972
    }
    # Stavanger
    norwaywest = {
      latitude  = 58.970232
      longitude = 5.728743
    }
    # Johannesburg
    southafricanorth = {
      latitude  = -26.203853
      longitude = 28.032469
    }
    # Cape Town
    southafricawest = {
      latitude  = -33.925476
      longitude = 18.421196
    }
    # Texas
    southcentralus = {
      latitude  = 31.495400
      longitude = -99.116830
    }
    # Singapore
    southeastasia = {
      latitude  = 1.355870
      longitude = 103.868959
    }
    # Chennai
    southindia = {
      latitude  = 13.088957
      longitude = 80.269426
    }
    # Gävle
    swedencentral = {
      latitude  = 60.674710
      longitude = 17.139526
    }
    # Zürich
    switzerlandnorth = {
      latitude  = 47.417808
      longitude = 8.536749
    }
    # Geneva
    switzerlandwest = {
      latitude  = 46.202704
      longitude = 6.142414
    }
    # Abu Dhabi
    uaecentral = {
      latitude  = 24.644255
      longitude = 54.384407
    }
    # Dubai
    uaenorth = {
      latitude  = 25.215755
      longitude = 55.267147
    }
    # London
    uksouth = {
      latitude  = 51.579637
      longitude = -0.127678
    }
    # Cardiff
    ukwest = {
      latitude  = 51.481341
      longitude = -3.180399
    }
    # Wyoming
    westcentralus = {
      latitude  = 43.032921
      longitude = -107.714721
    }
    # Netherlands
    westeurope = {
      latitude  = 52.185003
      longitude = 5.497931
    }
    # Mumbai
    westindia = {
      latitude  = 19.082846
      longitude = 72.868130
    }
    # California
    westus = {
      latitude  = 36.482618
      longitude = -119.553355
    }
    # Washington
    westus2 = {
      latitude  = 47.363976
      longitude = -120.115525
    }
    # Arizona
    westus3 = {
      latitude  = 34.217263
      longitude = -111.716047
    }
  }
}
