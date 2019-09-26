Class {
	#name : #MpAsynchronousRemoteMessage,
	#superclass : #MpRemoteMessage,
	#category : #'MyPrecious-Kernel'
}

{ #category : #communicating }
MpAsynchronousRemoteMessage >> deliverBy: transporter [
	transporter deliverAsynchronousMessage: self
]
