//
//  GCDBlackBox.swift
//  Virtual Tourist
//
//  Created by Seab on 8/31/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}
