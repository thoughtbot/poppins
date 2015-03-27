func dispatch_to_main(f: dispatch_block_t) {
    dispatch_async(dispatch_get_main_queue(), f)
}

func dispatch_to_background(f: dispatch_block_t) {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), f)
}

func dispatch_to_user_initiated(f: dispatch_block_t) {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), f)
}
