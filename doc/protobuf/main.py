import helloworld_pb2 as h


def test_default_value():
    """
    protobuf 将message 编码为一串key-value pairs
    field 为默认值的，key-value pairs为空
    """
    assert len(h.M1().SerializeToString()) == 0
    assert len(h.MessRepeated().SerializeToString()) == 0


def test_m2():
    m = h.M2(f_string="亚")
    m_byte = m.SerializeToString()
    field_key = get_filed_key(14, 2)

    m_byte_by_hand = bytes([field_key, 3, ]) + "亚".encode("utf8")

    my_print(m_byte, m_byte_by_hand)
    assert m_byte == m_byte_by_hand


def test_repeated():
    """
    repeated field 编码为多个key-value pairs，他们key相同
    field_type与string类型相同，为2
    """
    m = h.MessRepeated(f_repeated_m1=[h.M1(a=1), h.M1(a=1)])
    m_bytes = m.SerializeToString()
    field_number = 2
    field_type = 2
    field_key = get_filed_key(field_number, field_type)
    repeated_playload_length = 2
    one_field = bytes([field_key, repeated_playload_length]) + h.M1(a=1).SerializeToString()
    my_print(m_bytes, one_field + one_field)

    assert m_bytes == one_field + one_field


def test_repeated_pack():
    """
    varint, 32-bit, or 64-bit wire types 的repeated采用更高效的编码方式
    pack编码field_type与string类型相同，为2
    """
    m = h.MessRepeated(f_repeated_int32=[1, 1])
    m_bytes = m.SerializeToString()
    field_number = 1
    field_type = 2
    field_key = get_filed_key(field_number, field_type)
    repeated_playload_length = 2

    bytes_by_hand = bytes([field_key, repeated_playload_length, 1, 1])

    my_print(m_bytes, bytes_by_hand)

    assert m_bytes == bytes_by_hand


def test_m1():
    m1 = h.M1(a=1)
    filed_number = 1
    field_type = 0
    field_key = filed_number * 8 + field_type
    field_value = 1

    my_print(m1.SerializeToString(), bytes([field_key, field_value]))
    assert m1.SerializeToString() == bytes([field_key, field_value])

    m1 = h.M1(a=150)
    my_print(m1.SerializeToString(), bytes([0x08, 0x96, 0x01]))
    assert m1.SerializeToString() == bytes([0x08, 0x96, 0x01])


def get_filed_key(filed_number, field_type):
    return filed_number * 8 + field_type


def max_bit(i):
    assert type(i) == int
    if i < 0:
        raise Exception("unimplemented")
    elif i == 0:
        return 0
    else:
        max_bit = 0
        curr_i = i
        while curr_i > 0:
            curr_i = curr_i >> 1
            print(curr_i)
            max_bit += 1
            if curr_i == 0:
                return max_bit


def test_utf8():
    # 亚的unicode是0x4e9a 见http://unicode.scarfboy.com/m/?s=U%2B4E9A
    assert chr(ord("亚")) == "亚"
    assert ord("亚") == 0x4e9a
    if 0x00000800 <= ord("亚") <= 0x0000FFFF:
        print("亚 will encode in 3 bytes")
        assert len("亚".encode("utf8")) == 3
    print("unicode", bin(0x4e9a))
    print("utf8", [bin(i) for i in "亚".encode("utf8")])


def my_print(p, h):
    print("By proto:", [bin(i) for i in p])
    print("By hand :", [bin(i) for i in h])


if __name__ == '__main__':
    test_m2()
    test_utf8()
    test_repeated()
    test_repeated_pack()
    test_default_value()
    test_m1()
