Class {
	#name : 'MpAsynchronousRemoteMessage',
	#superclass : 'MpRemoteMessage',
	#category : 'MyPrecious-Messages',
	#package : 'MyPrecious',
	#tag : 'Messages'
}

{ #category : 'communicating' }
MpAsynchronousRemoteMessage >> deliverBy: transporter [
	transporter deliverAsynchronousMessage: self
]
