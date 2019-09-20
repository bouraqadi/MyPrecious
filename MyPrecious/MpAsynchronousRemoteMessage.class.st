Class {
	#name : #MpAsynchronousRemoteMessage,
	#superclass : #MpRemoteMessage,
	#category : #'MyPrecious-Kernel'
}

{ #category : #communicating }
MpAsynchronousRemoteMessage >> deliverByTransporter: transporter [
	transporter deliverAsynchronousMessage: self
]
