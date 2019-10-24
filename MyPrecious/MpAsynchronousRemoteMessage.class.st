Class {
	#name : #MpAsynchronousRemoteMessage,
	#superclass : #MpRemoteMessage,
	#category : #'MyPrecious-Messages'
}

{ #category : #communicating }
MpAsynchronousRemoteMessage >> deliverBy: transporter [
	transporter deliverAsynchronousMessage: self
]
