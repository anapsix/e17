#include "eobj.h"
#include "simple.h"

EAPI Eobj_Op SIMPLE_BASE_ID = 0;

typedef struct
{
   int a;
} Private_Data;

EAPI const Eobj_Event_Description _SIG_A_CHANGED =
        EOBJ_EVENT_DESCRIPTION("a,changed", "i", "Called when a has changed.");

static Eobj_Class *_my_class = NULL;

static void
_a_set(Eobj *obj, Eobj_Op op, va_list *list)
{
   Private_Data *pd = eobj_data_get(obj, _my_class);
   (void) op;
   int a;
   a = va_arg(*list, int);
   pd->a = a;
   printf("%s %d\n", __func__, pd->a);

   eobj_event_callback_call(obj, SIG_A_CHANGED, &pd->a);
}

Eina_Bool
_cb_added(void *data, Eobj *obj, const Eobj_Event_Description *desc, void *event_info)
{
   const Eobj_Event_Description *cb_desc = event_info;
   (void) data;
   (void) desc;

   if (cb_desc != SIG_A_CHANGED)
      return EINA_TRUE;

   int count = (int) eobj_generic_data_get(obj, "cb_count") + 1;
   eobj_generic_data_set(obj, "cb_count", (void *) count);

   printf("Added SIG_A_CHANGED callback to %p. Count: %d\n", obj, count);
   return EINA_TRUE;
}

Eina_Bool
_cb_deled(void *data, Eobj *obj, const Eobj_Event_Description *desc, void *event_info)
{
   const Eobj_Event_Description *cb_desc = event_info;
   (void) data;
   (void) desc;

   if (cb_desc != SIG_A_CHANGED)
      return EINA_TRUE;

   int count = (int) eobj_generic_data_get(obj, "cb_count") - 1;
   eobj_generic_data_set(obj, "cb_count", (void *) count);

   printf("Removed SIG_A_CHANGED callback from %p. Count: %d\n", obj, count);
   return EINA_TRUE;
}

static void
_constructor(Eobj *obj)
{
   eobj_constructor_super(obj);

   eobj_event_callback_add(obj, EOBJ_SIG_CALLBACK_ADD, _cb_added, NULL);
   eobj_event_callback_add(obj, EOBJ_SIG_CALLBACK_DEL, _cb_deled, NULL);

   eobj_generic_data_set(obj, "cb_count", (intptr_t) 0);
}

static void
_destructor(Eobj *obj)
{
   eobj_destructor_super(obj);
}

static void
_class_constructor(Eobj_Class *klass)
{
   const Eobj_Op_Func_Description func_desc[] = {
        EOBJ_OP_FUNC_DESCRIPTION(SIMPLE_ID(SIMPLE_SUB_ID_A_SET), _a_set),
        EOBJ_OP_FUNC_DESCRIPTION_SENTINEL
   };

   eobj_class_funcs_set(klass, func_desc);
}

const Eobj_Class *
simple_class_get(void)
{
   if (_my_class) return _my_class;

   static const Eobj_Op_Description op_desc[] = {
        EOBJ_OP_DESCRIPTION(SIMPLE_SUB_ID_A_SET, "i", "Set property A"),
        EOBJ_OP_DESCRIPTION_SENTINEL
   };

   static const Eobj_Event_Description *event_desc[] = {
        SIG_A_CHANGED,
        NULL
   };

   static const Eobj_Class_Description class_desc = {
        "Simple",
        EOBJ_CLASS_TYPE_REGULAR,
        EOBJ_CLASS_DESCRIPTION_OPS(&SIMPLE_BASE_ID, op_desc, SIMPLE_SUB_ID_LAST),
        event_desc,
        sizeof(Private_Data),
        _constructor,
        _destructor,
        _class_constructor,
        NULL
   };

   return _my_class = eobj_class_new(&class_desc, EOBJ_CLASS_BASE, NULL);
}
