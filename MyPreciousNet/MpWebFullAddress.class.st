Class {
	#name : #MpWebFullAddress,
	#superclass : #MpIpFullAddress,
	#instVars : [
		'protocol'
	],
	#category : #'MyPreciousNet-Web'
}

{ #category : #'accessing request' }
MpWebFullAddress class >> http [
	^#http
]

{ #category : #'accessing request' }
MpWebFullAddress class >> https [ 
	^#https
]

{ #category : #accessing }
MpWebFullAddress >> protocol [
	^ protocol
]

{ #category : #accessing }
MpWebFullAddress >> protocol: anObject [
	protocol := anObject
]

{ #category : #accessing }
MpWebFullAddress >> url [
	^String streamContents: [: stream |
		stream 
			<< self protocol;
			<< '://';
			print: self ip;
			<< $:;
			print: self port ]
]
