//
//  UrlsList.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 16/06/15.
//  Copyright (c) 2015 Mark Pervovskiy. All rights reserved.
//

import Foundation

public class UrlsList: StringArrayViewer {

    private let _imageUrls: [String]
            = ["https://lh5.googleusercontent.com/-4BnTwaLMjN4/THLLolmcWkI/AAAAAAAAErM/SYEVdjtLHIE/w744-h558-no/DSC02436.JPG"
            , "https://lh5.googleusercontent.com/-kQHLgfiFVpw/THLLtOu6GxI/AAAAAAAAErM/LVtw1eCZWDc/w744-h558-no/DSC02447.JPG"
            , "https://lh3.googleusercontent.com/-AHY2ecUMdmo/THLL3Z6v5mI/AAAAAAAAErM/zqbOVgjy2dw/w744-h558-no/DSC02453.JPG"
            , "https://google.com/"
            , "https://lh4.googleusercontent.com/-XF6yJxd965c/THLMDEzlNlI/AAAAAAAAErM/9D3ZQ8iWKsk/w744-h558-no/DSC02499.JPG"
            , "https://lh4.googleusercontent.com/-C733BofJ99w/THLMOjdDq8I/AAAAAAAAErM/qsYiRHVUJo0/w744-h558-no/DSC02512.JPG"
            , "https://lh5.googleusercontent.com/-D66r_cnhzN4/THLMSN_ryLI/AAAAAAAAErM/I9QemD81Jn8/w419-h558-no/DSC02516.JPG"
            , "https://lh3.googleusercontent.com/-HVXf9EhGopY/THVrZnqzVbI/AAAAAAAAErM/gpzOb0EmZjA/w744-h558-no/DSC02483.JPG"
            , "https://10.255.255.1:81/-AHSY2ecUMdmo/THLL3Z6v5mI/AAAAAAAAErM/zqbOVgjy2dw/w744-h558-no/BDSC02453.JPG_bad"
            , "https://lh5.googleusercontent.com/-OXo39aQ2C4E/TH_vA2afM6I/AAAAAAAAEss/zFQukbE8IG0/w419-h558-no/DSC05321.JPG"
            , "https://lh3.googleusercontent.com/-5H_C2bYMG-w/TH_vF-cU4PI/AAAAAAAAFbo/5Ai8ZgonBR0/w744-h558-no/DSC05323.JPG"
            , "https://lh3.googleusercontent.com/-6MoOBWz9sSk/TH_vOCAIZII/AAAAAAAAEs4/EzGhn67zI08/w419-h558-no/DSC05326.JPG"
            , "https://lh6.googleusercontent.com/-BGdtVzkJbD8/T8-vV3lATPI/AAAAAAAAFww/feTbMerzVbM/w419-h558-no/DSC07631.JPG"
            , "https://lh6.googleusercontent.com/-TirbyGjURlo/T8-ufztVgtI/AAAAAAAAFxY/pxp87DKtAno/w746-h558-no/DSC07607.JPG"
            , "https://lh3.googleusercontent.com/-AHY2ecSUMdmo/THLL3Z6v5mI/AAAAAAAAErM/zqbOVgjy2dw/w744-h558-no/BDSC02453.JPG_bad"
            , "https://lh6.googleusercontent.com/-4boG_Ew_7uc/T8-uMD46E8I/AAAAAAAAFxw/6gorG_N6gYQ/w744-h558-no/DSC07598.JPG"
            , "https://lh5.googleusercontent.com/-8jDjUfBjqY4/T7ZVYkEYBgI/AAAAAAAAFZE/cEDuJ4rJFP0/w744-h558-no/DSC07523.JPG"
            , "https://lh3.googleusercontent.com/-AHY2ecSUMdmo/THLL3Z6v5mI/AAAAAAAAErM/zqbOVgjy2dw/w744-h558-no/BDSC02453.JPG_bad"
            , "https://lh6.googleusercontent.com/-CEYVe5cKxTA/T7ZWJPNr6ZI/AAAAAAAAFZE/iLHp82CSVaI/w744-h558-no/DSC07534.JPG"
            , "https://lh3.googleusercontent.com/-HI6IrrD-3WQ/T7ZWJ_O1JpI/AAAAAAAAFZE/pLhU3uRHClA/w818-h558-no/DSC07539.JPG"
            , "https://lh4.googleusercontent.com/-X5voS1-1NGA/T8-v7rSGwiI/AAAAAAAAFu4/diphkVF0tcw/w744-h558-no/DSC07650.JPG"]

    public subscript(num: Int) -> String {
        return _imageUrls[num % _imageUrls.count]
    }

    public var count: Int {
        get {
            return _imageUrls.count * 5
        }
    }
}
