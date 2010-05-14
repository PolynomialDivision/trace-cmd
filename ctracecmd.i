// tracecmd.i
%module ctracecmd
%include "typemaps.i"
%include "constraints.i"

%apply Pointer NONNULL { struct tracecmd_input *handle };
%apply Pointer NONNULL { struct pevent *pevent };

/* return a (rec,cpu) tuple in python */
extern struct record *tracecmd_read_at(struct tracecmd_input *handle, 
                                       unsigned long long offset,
                                       int *OUTPUT);


%{
#include "trace-cmd.h"
%}


/* return python longs from unsigned long long functions */
%typemap(out) unsigned long long {
$result = PyLong_FromUnsignedLongLong((unsigned long long) $1);
}


%inline %{
PyObject *pevent_read_number_field_py(struct format_field *f, void *data)
{
        unsigned long long val;
        int ret;

        ret = pevent_read_number_field(f, data, &val);
        if (ret)
                Py_RETURN_NONE;
        else
                return PyLong_FromUnsignedLongLong(val);
}
%}

%ignore trace_seq_vprintf;

/* SWIG can't grok these, define them to nothing */
#define __trace
#define __attribute__(x)
#define __thread

%include "trace-cmd.h"
%include "parse-events.h"
