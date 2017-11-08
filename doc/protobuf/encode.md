# protobuf
## filed type
- 0	Varint	
	- int32 
	- int64
	- uint32
	- uint64
	- sint32
	- sint64
	- bool
	- enum
- 1	64-bit	
	- fixed64
	- sfixed64
	- double
- 2	Length-delimited(first part is length varint) 
	- string
	- bytes
	- embedded messages
	- packed repeated fields
- 5	32-bit	
	- fixed32
	- sfixed32
	- float
## varint
- `1xxx xxxx   1xxx xxxx   xxxx xxxx`
- p = 8+(n-1)*7 
## ZigZag encoding
- sint32 `(n << 1) ^ (n >> 31)`
- sint64 `(n << 1) ^ (n >> 63)`
# utf8
```python
def encode_len(char):
	if 0x0000_0000< ord(char)<0x0000_007f:
		# 0xxx_xxxx
		return 1
	elif 0x0000_0080 <ord(char)<0x0000_07FF:
		# 110x_xxxx 10xx_xxxx 
		return 2
	elif 0x0000_0800 <ord(char)<0x0000_FFFF:
		# 1110_xxxx 10xx_xxxx 10xx_xxxx
		return 3
	elif 0x0001_0000 <ord(char) <0x0010_FFFF:
		# 1111_xxxx 10xx_xxxx 10xx_xxxx 10xx_xxxx
		return 4

def test_utf8():
    # 亚的unicode是0x4e9a 见http://unicode.scarfboy.com/m/?s=U%2B4E9A
    assert chr(ord("亚")) == "亚"
    assert ord("亚") == 0x4e9a
    if 0x00000800 <= ord("亚") <= 0x0000FFFF:
        print("亚 will encode in 3 bytes")
        assert len("亚".encode("utf8")) == 3
    print("unicode", bin(0x4e9a))
    print("utf8", [bin(i) for i in "亚".encode("utf8")])
```

# base64
`xxxx_xxxx xxxx_xxxx xxxx_xxxx` -> 
`xxxx_xx|xx xxxx|_xxxx xx|xx_xxxx`
如果目标bytes长度不是3的倍数padding
`xxxx_xx|xx 0000|_0000 00|00_0000`