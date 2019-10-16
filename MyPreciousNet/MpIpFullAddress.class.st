Class {
	#name : #MpIpFullAddress,
	#superclass : #Object,
	#traits : 'TEquality',
	#classTraits : 'TEquality classTrait',
	#instVars : [
		'ip',
		'port'
	],
	#category : #'MyPreciousNet-Tcp'
}

{ #category : #'instance creation' }
MpIpFullAddress class >> ip: ip port: port [
	^self new
		ip: ip;
		port: port;
		yourself
]

{ #category : #accessing }
MpIpFullAddress >> ip [
	^ ip
]

{ #category : #accessing }
MpIpFullAddress >> ip: anObject [
	ip := anObject
]

{ #category : #accessing }
MpIpFullAddress >> port [
	^ port
]

{ #category : #accessing }
MpIpFullAddress >> port: anObject [
	port := anObject
]

{ #category : #printing }
MpIpFullAddress >> printOn: aStream [
	aStream
		<< 'IP: ';
		print: self ip;
		<< ' - Port: ';
		<< self port
]
