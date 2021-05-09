# "New Release: PHCurry"

programming languages.

Currying is a concept from functional programming where you allow you a function that would normally need `n` arguments to be called with fewer arguments. When you do this it will return a function with you current arguments stored, but waiting for the extra arguments. When all arguments are finally stored/passed the function will be invoked.

An Example:

```php
<?php
require_once 'phcurry.php';

$volumeCalculator = function($w, $h, $l) {
    return $w * $h * $l;
};
$iKnowTheWidth = phcurry($volumeCalculator, 3);
$iKnowTheWidthAndHeight = $iKnowTheWidth(2);
echo "The volume is " . $iKnowTheWidthAndHeight(4);
?>
```

## That's great, but what is the use...

Why not think about a mapping function...

```php
<?php
require_once 'phcurry.php';

$map = function($func, $collection) { // Only required because
    return array_map($func, $collection);
};

$getId = function($obj) { return $obj['id']; };

$getIds = phcurry($map, $getId);

$data = array(
    array('id'=>'f3ds', 'name'=> 'Jack'),
    array('id'=>'adb9', 'name'=> 'Jill'),
    array('id'=>'93cd', 'name'=> 'John'),
    array('id'=>'e236', 'name'=> 'Jude')
);

echo "The user Ids are: " . implode(', ', $getIds($data));
?>
```

Yes but you could have achieved this with:

```php
<?php
echo "The user Ids are: " . implode(
    ', ',
    array_map(function($obj) { return $obj['id']; }, $data)
);
?>
```

That is true, I would argue that the previous was better because it is broken up into smaller parts which could be more testable and because each little function is named after it's actually doing. PHCurry is still not proving to be **that** useful though, but combining it with [PHChain](https://github.com/forbesmyester/PHChain) so you can chain these tiny functions together you can take it a little further...

```php
<?php
require_once 'phcurry.php';
require_once '../phchain/phchain.php';

// Gets the relative path of a file relative to a parent directory
// TODO: Make this not throw exceptions when it is not within the parent
$getRelativePath = function($parentPath, $absoluteChildPath) {
    if (substr($absoluteChildPath, 0, strlen($parentPath)) != $parentPath) {
        throw new Exception($absoluteChildPath . ' is not stored beneath ' . $parentPath);
    }
    return preg_replace(
        '/^\//',
        '',
        substr($absoluteChildPath, strlen($parentPath))
    );
};

$extractField = function($field, $record) {
    return $record[$field];
};

$extractRelativePath = phchain(array(
    phcurry($extractField, 'location'),
    phcurry(
        $getRelativePath,
        '/home/fozz'
    )
));

$relativePaths = array_map(
    $extractRelativePath,
    array(
        array(
            'location'=>'/home/fozz/Documents/CV.html',
            'description'=>'All about me!'
        ),
        array(
            'location'=>"/home/fozz/Music/MC Hammer - Can't Touch This.mp3",
            'description'=>"Super famous early 90's song"
        ),
        array(
            'location'=>'/home/fozz/Music/Blur - Parklife.mp3',
            'description'=>"Super famous mid 90's song"
        ),
        array(
            'location'=>'/home/fozz/Projects/phcurry/README.md',
            'description'=>"phcurry's README in Markdown format"
        )
    )
);

echo "Inside your my directory I have I have the following files:\n";
echo implode("\t\n", $relativePaths);
?>
```

