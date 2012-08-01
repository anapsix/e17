#ifndef ELM_WIDGET_LABEL_H
#define ELM_WIDGET_LABEL_H

#include "elm_widget_layout.h"

#ifdef HAVE_EIO
# include <Eio.h>
#endif

/**
 * @addtogroup Widget
 * @{
 *
 * @section elm-label-class The Elementary Label Class
 *
 * Elementary, besides having the @ref Label widget, exposes its
 * foundation -- the Elementary Label Class -- in order to create other
 * widgets which are a label with some more logic on top.
 */

/**
 * @def ELM_LABEL_CLASS
 *
 * Use this macro to cast whichever subclass of
 * #Elm_Label_Smart_Class into it, so to access its fields.
 *
 * @ingroup Widget
 */
#define ELM_LABEL_CLASS(x) ((Elm_Label_Smart_Class *)x)

/**
 * @def ELM_LABEL_DATA
 *
 * Use this macro to cast whichever subdata of
 * #Elm_Label_Smart_Data into it, so to access its fields.
 *
 * @ingroup Widget
 */
#define ELM_LABEL_DATA(x)  ((Elm_Label_Smart_Data *)x)

/**
 * @def ELM_LABEL_SMART_CLASS_VERSION
 *
 * Current version for Elementary label @b base smart class, a value
 * which goes to _Elm_Label_Smart_Class::version.
 *
 * @ingroup Widget
 */
#define ELM_LABEL_SMART_CLASS_VERSION 1

/**
 * @def ELM_LABEL_SMART_CLASS_INIT
 *
 * Initializer for a whole #Elm_Label_Smart_Class structure, with
 * @c NULL values on its specific fields.
 *
 * @param smart_class_init initializer to use for the "base" field
 * (#Evas_Smart_Class).
 *
 * @see EVAS_SMART_CLASS_INIT_NULL
 * @see EVAS_SMART_CLASS_INIT_NAME_VERSION
 * @see ELM_LABEL_SMART_CLASS_INIT_NULL
 * @see ELM_LABEL_SMART_CLASS_INIT_NAME_VERSION
 *
 * @ingroup Widget
 */
#define ELM_LABEL_SMART_CLASS_INIT(smart_class_init) \
  {smart_class_init, ELM_LABEL_SMART_CLASS_VERSION}

/**
 * @def ELM_LABEL_SMART_CLASS_INIT_NULL
 *
 * Initializer to zero out a whole #Elm_Label_Smart_Class structure.
 *
 * @see ELM_LABEL_SMART_CLASS_INIT_NAME_VERSION
 * @see ELM_LABEL_SMART_CLASS_INIT
 *
 * @ingroup Widget
 */
#define ELM_LABEL_SMART_CLASS_INIT_NULL \
  ELM_LABEL_SMART_CLASS_INIT(EVAS_SMART_CLASS_INIT_NULL)

/**
 * @def ELM_LABEL_SMART_CLASS_INIT_NAME_VERSION
 *
 * Initializer to zero out a whole #Elm_Label_Smart_Class structure and
 * set its name and version.
 *
 * This is similar to #ELM_LABEL_SMART_CLASS_INIT_NULL, but it will
 * also set the version field of #Elm_Label_Smart_Class (base field)
 * to the latest #ELM_LABEL_SMART_CLASS_VERSION and name it to the
 * specific value.
 *
 * It will keep a reference to the name field as a <c>"const char *"</c>,
 * i.e., the name must be available while the structure is
 * used (hint: static or global variable!) and must not be modified.
 *
 * @see ELM_LABEL_SMART_CLASS_INIT_NULL
 * @see ELM_LABEL_SMART_CLASS_INIT
 *
 * @ingroup Widget
 */
#define ELM_LABEL_SMART_CLASS_INIT_NAME_VERSION(name) \
  ELM_LABEL_SMART_CLASS_INIT                          \
    (ELM_LAYOUT_SMART_CLASS_INIT_NAME_VERSION(name))

/**
 * Elementary label base smart class. This inherits directly from
 * #Elm_Layout_Smart_Class and is meant to build widgets extending the
 * behavior of a label.
 *
 * All of the functions listed on @ref Label namespace will work for
 * objects deriving from #Elm_Label_Smart_Class.
 */
typedef struct _Elm_Label_Smart_Class
{
   Elm_Layout_Smart_Class base;

   int                    version;    /**< Version of this smart class definition */
} Elm_Label_Smart_Class;

/**
 * Base layout smart data extended with label instance data.
 */
typedef struct _Elm_Label_Smart_Data Elm_Label_Smart_Data;
struct _Elm_Label_Smart_Data
{
   Elm_Layout_Smart_Data base;

   const char           *format;
   double                slide_duration;
   Evas_Coord            lastw;
   Evas_Coord            wrap_w;
   Elm_Wrap_Type         linewrap;

   Eina_Bool             ellipsis : 1;
   Eina_Bool             slidingmode : 1;
   Eina_Bool             slidingellipsis : 1;
};

/**
 * @}
 */

EAPI extern const char ELM_LABEL_SMART_NAME[];
EAPI const Elm_Label_Smart_Class *elm_label_smart_class_get(void);

#define ELM_LABEL_DATA_GET(o, sd) \
  Elm_Label_Smart_Data * sd = evas_object_smart_data_get(o)

#define ELM_LABEL_DATA_GET_OR_RETURN(o, ptr)         \
  ELM_LABEL_DATA_GET(o, ptr);                        \
  if (!ptr)                                          \
    {                                                \
       CRITICAL("No widget data for object %p (%s)", \
                o, evas_object_type_get(o));         \
       return;                                       \
    }

#define ELM_LABEL_DATA_GET_OR_RETURN_VAL(o, ptr, val) \
  ELM_LABEL_DATA_GET(o, ptr);                         \
  if (!ptr)                                           \
    {                                                 \
       CRITICAL("No widget data for object %p (%s)",  \
                o, evas_object_type_get(o));          \
       return val;                                    \
    }

#define ELM_LABEL_CHECK(obj)                     \
  if (!obj || !elm_widget_type_check             \
        ((obj), ELM_LABEL_SMART_NAME, __func__)) \
    return

#endif
