# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: cn.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor.FileDescriptor(
  name='cn.proto',
  package='',
  syntax='proto3',
  serialized_pb=_b('\n\x08\x63n.proto\"\x0f\n\x02\x63n\x12\t\n\x01\x61\x18\x01 \x01(\tb\x06proto3')
)




_CN = _descriptor.Descriptor(
  name='cn',
  full_name='cn',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='a', full_name='cn.a', index=0,
      number=1, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=12,
  serialized_end=27,
)

DESCRIPTOR.message_types_by_name['cn'] = _CN
_sym_db.RegisterFileDescriptor(DESCRIPTOR)

cn = _reflection.GeneratedProtocolMessageType('cn', (_message.Message,), dict(
  DESCRIPTOR = _CN,
  __module__ = 'cn_pb2'
  # @@protoc_insertion_point(class_scope:cn)
  ))
_sym_db.RegisterMessage(cn)


# @@protoc_insertion_point(module_scope)
