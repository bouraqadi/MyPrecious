Class {
	#name : #MpConnectedTransporterForTest,
	#superclass : #MpConnectedTransporter,
	#traits : 'MpTConnectedTransporterForTest',
	#classTraits : 'MpTConnectedTransporterForTest classTrait',
	#instVars : [
		'connectionQueue'
	],
	#category : #'MyPreciousTests-Connected'
}

{ #category : #accessing }
MpConnectedTransporterForTest >> connectionQueue [
	^ connectionQueue
]

{ #category : #initialization }
MpConnectedTransporterForTest >> initialize [
	super initialize.
	connectionQueue := SharedQueue new
]

{ #category : #receiving }
MpConnectedTransporterForTest >> startServiceReceivingVia: connection [
	[ self receiveBytesVia: connection ] fork
]
