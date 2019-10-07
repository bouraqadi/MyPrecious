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

{ #category : #connecting }
MpConnectedTransporterForTest >> connectionClass [
	^MpOneShotConnectionForTest
]

{ #category : #accessing }
MpConnectedTransporterForTest >> connectionQueue [
	^ connectionQueue
]

{ #category : #initialization }
MpConnectedTransporterForTest >> initialize [
	super initialize.
	connectionQueue := SharedQueue new
]
