<?php
/*
 * This file is part of the sfDoctrine package.
 * (c) 2006-2008 Olivier Verdier <Olivier.Verdier@gmail.com>
 * (c) 2006-2008 Jonathan H. Wage <jonwage@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

/**
 * ObjectHelper for doctrine admin generator.
 *
 * @package    sfDoctrinePlugin
 * @subpackage helper
 * @author     Olivier Verdier <Olivier.Verdier@gmail.com>
 * @author     Jonathan H. Wage <jonwage@gmail.com>
 * @version    SVN: $Id: ObjectDoctrineAdminHelper.php 8687 2008-04-30 03:05:15Z Jonathan.Wage $
 */

use_helper('ObjectAdmin');

/**
 * object_doctrine_admin_double_list
 *
 * @param string $object 
 * @param string $method 
 * @param string $options 
 * @return void
 */
function object_doctrine_admin_double_list($object, $method, $options = array())
{
  return object_admin_double_list($object, $method, $options, '_get_doctrine_object_list');
}

/**
 * object_doctrine_admin_select_list
 *
 * @param string $object 
 * @param string $method 
 * @param string $options 
 * @return void
 */
function object_doctrine_admin_select_list($object, $method, $options = array())
{
  return object_admin_select_list($object, $method, $options, '_get_doctrine_object_list');
}

/**
 * object_doctrine_admin_check_list
 *
 * @param string $object 
 * @param string $method 
 * @param string $options 
 * @return void
 */
function object_doctrine_admin_check_list($object, $method, $options = array())
{
  return object_admin_check_list($object, $method, $options, '_get_doctrine_object_list');
}

/**
 * _get_doctrine_object_list
 *
 * @param string $object 
 * @param string $method 
 * @param string $options 
 * @return void
 */
function _get_doctrine_object_list($object, $method, $options)
{
  $foreignTable = $object->getTable()->getRelation($method[1][0])->getTable();
  $foreignClass = $foreignTable->getComponentName();

  if (isset($options['dql']))
  {
    $dql = $options['dql'];
    unset($options['dql']); # Otherwise it will show up in the html

    $allObjects = $foreignTable->findByDQL($dql);
  } else {
    $allObjects = $foreignTable->findAll();
  }

  $associatedObjects = $object->get($method[1][0]);
  
  $ids = array();
  foreach ($associatedObjects as $associatedObject)
  {
    $ids[] = $associatedObject->identifier();
  }

  if ($associatedObjects instanceof Doctrine_Collection && $associatedObjects->count() === 0)
  {
    $associatedObjects = null;
  }
 
  return array($allObjects, $associatedObjects, $ids);
}

/**
 * object_enum_tag
 *
 * @param string $object 
 * @param string $method 
 * @param string $options 
 * @return void
 */
function object_enum_tag($object, $method, $options)
{
  $enumValues = _get_option($options, 'enumValues', array());
  $currentValue = _get_object_value($object, $method);
  $enumValues = array_combine($enumValues, $enumValues);
  
  return select_tag(_convert_method_to_name($method, $options), options_for_select($enumValues, $currentValue), $options);
}