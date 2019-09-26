Class {
	#name : #MpAsynchronousTransporterOLD,
	#superclass : #MpTransporter,
	#instVars : [
		'promisesDict',
		'promisesLock'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #sending }
MpAsynchronousTransporterOLD >> basicSendMessage: remoteMessage to: targetReference [
	[
		self sendObject: remoteMessage toAddress: targetReference address
	] on: Error do: [ : ex | 
		MpCouldNotDeliverMessageError new
			message: remoteMessage;
			originalException: ex;
			signal
	]
]

{ #category : #accessing }
MpAsynchronousTransporterOLD >> promisesDict [
	^ promisesDict
]
