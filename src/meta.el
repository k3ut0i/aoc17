(cl-defun generate-random-num-list (&optional (length 10) (limit 10))
  (let (result)
    (loop repeat length
	  do (push (random limit) result))
    result))
